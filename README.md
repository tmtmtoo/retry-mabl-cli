# retry-mabl-cli

## motivation

End-to-end (E2E) tests are prone to failure due to environmental dependencies. Therefore, it is common for E2E testing frameworks to provide a retry mechanism. mabl is no exception, and it offers a built-in retry mechanism for tests executed in the cloud environment. However, the mabl CLI tool (mabl cli) does not seem to have any retry functionality implemented. This is why I am developing a tool that can be used to conveniently retry tests with mabl cli.

## usage

```.bash
$ mabl tests run {{YOUR_OPTIONS}} \
  | tee test-run.log
$ curl -sL https://raw.githubusercontent.com/tmtmtoo/retry-mabl-cli/2.16.4/extract_failed_test_id.sh \
  | bash -s test-run.log \
  | xargs -L 1 mabl tests run {{YOUR_OPTIONS}} --id
```
