#include "ptymanager.h"
#include <QCoreApplication>
#include <QDebug>
#include <QTimer>
#include <QtConcurrent/QtConcurrent>

PtyManager::PtyManager(QObject *parent)
    : QObject(parent), shell_path_("/bin/bash") {
  initPty();
}

void PtyManager::setMessage(const QString &msg) {
  QByteArray array = msg.toUtf8();
  if (!array.endsWith("\n")) {
    array += "\n";
  }
  write(fd_master_, array.data(), array.size());
}

int PtyManager::initPty() {
  fd_master_ = posix_openpt(O_RDWR);
  if (fd_master_ < 0) {
    fprintf(stderr, "Error %d on posix_openpt()\n", errno);
    return 1;
  }

  int rc = grantpt(fd_master_);
  if (rc != 0) {
    fprintf(stderr, "Error %d on grantpt()\n", errno);
    return 1;
  }

  rc = unlockpt(fd_master_);
  if (rc != 0) {
    fprintf(stderr, "Error %d on unlockpt()\n", errno);
    return 1;
  }

  // Open the slave side ot the PTY
  fd_slave_ = open(ptsname(fd_master_), O_RDWR);

  // Create the child process
  auto pid = fork();
  if (pid) {
    runMasterProcess();
  } else {
    runSlaveProcess();
  }

  return 0;
}

void PtyManager::runMasterProcess() {
  // FATHER
  // Close the slave side of the PTY
  close(fd_slave_);

  // run in thread
  QtConcurrent::run([=] {
    fd_set fd_in;
    int rc;
    char input[150];

    while (true) {
      // Wait for data from standard input and master side of PTY
      FD_ZERO(&fd_in);
      FD_SET(0, &fd_in);
      FD_SET(fd_master_, &fd_in);

      rc = select(fd_master_ + 1, &fd_in, NULL, NULL, NULL);
      switch (rc) {
        case -1:
          fprintf(stderr, "Error %d on select()\n", errno);
          exit(1);

        default: {
          // If data on standard input
          if (FD_ISSET(0, &fd_in)) {
            rc = read(0, input, sizeof(input));
            if (rc > 0) {
              // Send data on the master side of PTY
              // we can send data from our UI too
              write(fd_master_, input, rc);
            } else {
              if (rc < 0) {
                fprintf(stderr, "Error %d on read standard input\n", errno);
                exit(1);
              }
            }
          }

          // If data on master side of PTY
          // It mean the data is send from slave's output
          if (FD_ISSET(fd_master_, &fd_in)) {
            rc = read(fd_master_, input, sizeof(input));
            if (rc > 0) {
#ifdef QT_DEBUG
              // Send data on standard output
              write(1, input, rc);
#endif
              // send data to UI too
              QString msg(QByteArray(input, rc));
              emit messageArrived(msg);
            } else {
              if (rc < 0) {
                fprintf(stderr, "Error %d on read master PTY\n", errno);
                exit(1);
              }
            }
          }
        }
      }  // End switch
    }    // End while
  });
}

void PtyManager::runSlaveProcess() {
  struct termios slave_orig_term_settings;  // Saved terminal settings
  struct termios new_term_settings;         // Current terminal settings

  // CHILD

  // Close the master side of the PTY
  close(fd_master_);

  // Save the defaults parameters of the slave side of the PTY
  int rc = tcgetattr(fd_slave_, &slave_orig_term_settings);

  // Set RAW mode on slave side of PTY
  new_term_settings = slave_orig_term_settings;
  cfmakeraw(&new_term_settings);
  tcsetattr(fd_slave_, TCSANOW, &new_term_settings);

  // The slave side of the PTY becomes the standard input and outputs of the
  // child process
  close(0);  // Close standard input (current terminal)
  close(1);  // Close standard output (current terminal)
  close(2);  // Close standard error (current terminal)

  dup(fd_slave_);  // PTY becomes standard input (0)
  dup(fd_slave_);  // PTY becomes standard output (1)
  dup(fd_slave_);  // PTY becomes standard error (2)

  // Now the original file descriptor is useless
  close(fd_slave_);

  // Make the current process a new session leader
  setsid();

  // As the child is a session leader, set the controlling terminal to be the
  // slave side of the PTY
  // (Mandatory for programs like the shell to make them manage correctly
  // their outputs)
  ioctl(0, TIOCSCTTY, 1);

  // Execution of the program
  {
    char **child_av;
    // Build the command line
    child_av = (char **)malloc(shell_args_.size() + 1 * sizeof(char *));
    for (int i = 1; i < shell_args_.size(); i++) {
      child_av[i] = strdup(shell_args_.at(i).toUtf8().data());
    }
    child_av[shell_args_.size() - 1] = NULL;
    rc = execvp(shell_path_.toUtf8().data(), nullptr);
  }
  //    // if Error...
  //    return 1;
}
