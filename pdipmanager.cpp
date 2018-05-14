#include "pdipmanager.h"
#include <QDebug>

PdipManager::PdipManager(QObject *parent) : QObject(parent) {
  // Let the service manage the SIGCHLD signal as we don't fork/exec any
  // other program
  int rc = pdip_configure(1, 0);
  if (rc != 0) {
    fprintf(stderr, "pdip_configure(): '%m' (%d)\n", errno);
  }
  // Create a PDIP object
  pdip_cfg_init(&cfg_);
  // The bash prompt is displayed on stderr. So, to synchronize on it, we must
  // redirect stderr to the PTY between PDIP and bash
  cfg_.flags |= PDIP_FLAG_ERR_REDIRECT;
  cfg_.debug_level = 0;
  pdip_ = pdip_new(&cfg_);
  if (!pdip_) {
    fprintf(stderr, "pdip_new(): '%m' (%d)\n", errno);
  }

  // Export the prompt of the BASH shell
  rc = setenv("PS1", "PROMPT> ", 1);
  if (rc != 0) {
    fprintf(stderr, "setenv(PS1): '%m' (%d)\n", errno);
  }

  // Attach a bash shell to the PDIP object
  char *bash_av[2];
  bash_av[0] = "/bin/bash";
  bash_av[1] = (char *)0;
  rc = pdip_exec(pdip_, 1, bash_av);
  if (rc != 0) {
    fprintf(stderr, "pdip_exec(bash): '%m' (%d)\n", errno);
  }

  // Synchronize on the first displayed prompt
  char *display;
  size_t display_sz;
  size_t data_sz;
  display = (char *)0;
  display_sz = 0;
  data_sz = 0;
  rc = pdip_recv(&pdip_, "^PROMPT> ", &display, &display_sz, &data_sz,
                 (struct timeval *)0);
  if (rc != PDIP_RECV_FOUND) {
    fprintf(stderr, "pdip_recv(): Unexpected return code %d\n", rc);
  }

  // Display the result
  printf("%s", display);

  // Execute the "ls -la /" command
  rc = pdip_send(pdip_, "ls -la /\n");
  if (rc < 0) {
    fprintf(stderr, "pdip_send(ls -la /): '%m' (%d)\n", errno);
  }

  // Synchronize on the prompt displayed right after the command execution
  // We pass the same buffer that will be eventually reallocated
  rc = pdip_recv(&pdip_, "^PROMPT> ", &display, &display_sz, &data_sz,
                 (struct timeval *)0);
  if (rc != PDIP_RECV_FOUND) {
    fprintf(stderr, "pdip_recv(): Unexpected return code %d\n", rc);
  }

  // Display the result
  printf("%s", display);
}

void PdipManager::sendMessage(const QString &msg) {}
