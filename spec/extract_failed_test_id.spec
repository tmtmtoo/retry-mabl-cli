Describe 'extract_failed_test_id.sh'

  It 'If given a mabl cli test execution log file, the test-id of the failed test is displayed.'
    When run ./extract_failed_test_id.sh test-run.log
    The stdout should be present
    The status should be success
  End

  It 'If no file is given, print an error message and exit'
    When run ./extract_failed_test_id.sh
    The stderr should equal 'Input a log file name as argument.'
    The stdout should not be present
    The status should be failure
  End

  It 'If the file is inconsistent, print and error message and exit'
    When run ./extract_failed_test_id.sh test-run-inconsistent.log
    The stderr should equal 'Invalid log file format.'
    The stdout should not be present
    The status should be failure
  End

  It 'If an unrelated file is given, empty output'
    When run ./extract_failed_test_id.sh README.md
    The stderr should not be present
    The stdout should not be present
    The status should be success
  End
End
