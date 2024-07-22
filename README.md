# http_status_rater

Simple bash script for Linux and MacOS to check HTTP statuses of URL and get percentage for each of them.

Usage:

```bash
./http_status_rater.sh <URL> <request_count>
```

Example:

```bash
$ ./http_status_rater.sh https://www.google.com 10 

+----+--------+-------+------------------------+------------------+
| ## | Status | Proto | Server                 | X-Powered-By     |
+----+--------+-------+------------------------+------------------+
|  1 | 200    | 2     | gws                    | N/A              |
|  2 | 200    | 2     | gws                    | N/A              |
|  3 | 200    | 2     | gws                    | N/A              |
|  4 | 200    | 2     | gws                    | N/A              |
|  5 | 200    | 2     | gws                    | N/A              |
|  6 | 200    | 2     | gws                    | N/A              |
|  7 | 200    | 2     | gws                    | N/A              |
|  8 | 200    | 2     | gws                    | N/A              |
|  9 | 200    | 2     | gws                    | N/A              |
| 10 | 200    | 2     | gws                    | N/A              |
+----+--------+-------+------------------------+------------------+
```
