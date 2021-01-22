MODULE tea_caliper_module
  USE caliper_mod

  IMPLICIT NONE

  TYPE(ConfigManager) :: mgr

CONTAINS

! Start the Caliper ConfigManager. 
! Reads a profiling configuration from the command line.
SUBROUTINE tea_caliper_start()
    INTEGER               :: argc
    LOGICAL               :: ret
    CHARACTER(len=:), allocatable :: errmsg
    CHARACTER(len=256)    :: arg

    mgr = ConfigManager_new()
    argc = command_argument_count()
    if (argc .ge. 1) then
        CALL get_command_argument(1, arg)
        CALL mgr%add(arg)
        ret = mgr%error()
        if (ret) then
            errmsg = mgr%error_msg()
            write(*,*) 'ConfigManager: ', errmsg
        endif
    endif

    ! Start configured profiling channels
    CALL mgr%start
END SUBROUTINE tea_caliper_start


SUBROUTINE tea_caliper_flush()
    CALL mgr%flush
    CALL ConfigManager_delete(mgr)

    CALL cali_flush(0)
END SUBROUTINE tea_caliper_flush

END MODULE tea_caliper_module