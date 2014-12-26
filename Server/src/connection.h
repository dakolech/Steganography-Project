#pragma once

struct LogStatus {
    int status;
    char user_id[5];
};

struct LogStatus conn_log_user(int socket);
void conn_wait_for_requests();
