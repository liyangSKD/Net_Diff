! ================  ZTD_EGNOS  ================
!
! PURPOSE:
!           Calculate the Zenith Delay of tropsphere by using 
!        the EGNOS Model
!
! REFERENCES:
!       http://www.navipedia.net/index.php/Tropospheric_Delay
! 
! INPUTS:
!       B        latitude(degree)
!       H        Height(m)
!       DOY   day of year
!
! OUTPUTS:
!      ZHD    Zenith Hydrostatic Delay(m)
!      ZWD   Zenith Wet Delay(m)
!
! WRITTEN BY: Yize Zhang, zhyize@163.com, Tongji & SHAO
! ================  End of header  ===============

subroutine ZTD_EGNOS(B, H, DOY, ZHD,ZWD)
use MOD_constant
implicit none
    ! Intent in
    real(8) :: B, H
    integer :: DOY
    ! Intent out
    real(8) :: ZHD, ZWD
    ! Local variable
    integer:: doymin
    real(8) :: absB
    real(8) :: k, m, P, beta, T, e, ranta
    
    if (B>0) then
        doymin=28
    else
        doymin=211
    end if

    k=dcos(2.d0*pi*(DOY-doymin)/365.25d0)
    absB=dabs(B)
    if (absB<15.d0)  then
        P=1013.25d0
        beta=6.3d0
        T=299.65d0
        e=26.31d0
        ranta=2.77d0
    elseif (absB<30.d0) then
        m=(absB-15.d0)/15.d0
        P=1013.25d0+m*(1017.25d0-1013.25d0)-(m*(-3.75d0))*k
        beta=6.3d0+m*(6.05d0-6.30d0)-(m*(0.25d0))*k
        T=299.65d0+m*(294.15d0-299.65d0)-(m*(7.00d0))*k
        e=26.31d0+m*(21.79d0-26.31d0)-(m*(8.85d0))*k
        ranta=2.77d0+m*(3.15d0-2.77d0)-(m*(0.33d0))*k
    elseif (absB<45.d0) then
        m=(absB-30.d0)/15.d0
        P=1017.25d0+m*(1015.75d0-1017.25d0)-(-3.75d0+m*(-2.25d0+3.75d0))*k
        beta=6.05d0+m*(5.58d0-6.05d0)-(0.25d0+m*(0.32d0-0.25d0))*k
        T=294.15d0+m*(283.15d0-294.15d0)-(7.d0+m*(11.d0-7.d0))*k
        e=21.79d0+m*(11.66d0-21.79d0)-(8.85d0+m*(7.24d0-8.85d0))*k
        ranta=3.15d0+m*(2.57d0-3.15d0)-(0.33d0+m*(0.46d0-0.33d0))*k
    elseif (absB<60.d0) then
        m=(absB-45.d0)/15.d0
        P=1015.75d0+m*(1011.75d0-1015.75d0)-(-2.25d0+m*(-1.75d0+2.25d0))*k
        beta=5.58d0+m*(5.39d0-5.58d0)-(0.32d0+m*(0.81d0-0.32d0))*k
        T=283.15d0+m*(272.15d0-283.15d0)-(11.d0+m*(15.d0-11.d0))*k
        e=11.66d0+m*(6.78d0-11.66d0)-(7.24d0+m*(5.36d0-7.24d0))*k
        ranta=2.57d0+m*(1.81d0-2.57d0)-(0.46d0+m*(0.74d0-0.46d0))*k
    elseif (absB<75.d0) then
        m=(absB-60.d0)/15.d0
        P=1011.75d0+m*(1013.d0-1011.75d0)-(-1.75d0+m*(-0.5d0+1.75d0))*k
        beta=5.39d0+m*(4.53d0-5.39d0)-(0.81d0+m*(0.62d0-0.81d0))*k
        T=272.15d0+m*(263.65d0-272.15d0)-(15.d0+m*(14.5d0-15.d0))*k
        e=6.78d0+m*(4.11d0-6.78d0)-(5.36d0+m*(3.39d0-5.36d0))*k
        ranta=1.81d0+m*(1.55d0-1.81d0)-(0.74d0+m*(0.30d0-0.74d0))*k
    else
        P=1013.d0+0.5d0*k
        beta=4.53d0-0.62d0*k
        T=263.65d0-14.5d0*k
        e=4.11d0-3.39d0*k
        ranta=1.55d0-0.30d0*k
    end if

    ZHD=(77.604d-6)*287.054d0*P/9.784d0   ! ZHD at the sea level
    ZWD=0.382d0*287.054d0/(9.784d0*(ranta+1.d0)-beta/1000.d0*287.054d0)*e/T    ! ZWD at the sea level
    ZHD=ZHD*(1.d0-beta/1000.d0*H/T)**(9.80665d0/287.054d0/(beta/1000.d0))    ! ZHD at the station
    ZWD=ZWD*(1.d0-beta/1000.d0*H/T)**((ranta+1)*9.80665d0/287.054d0/(beta/1000.d0)-1.d0)    ! ZWD at the station
    
end subroutine