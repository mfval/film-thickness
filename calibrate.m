function [returnValue, returnValue2] = calibrate( nbrepeat, interactive, filepathname1)
%CALIBRATE
%   This is function is a helper function to measure distance, where
%   justCalibrate is always true
    if( nargout == 1)
        returnValue = measureobject(nbrepeat, interactive, true, filepathname1);
    else
        [returnValue, returnValue2] = measureobject(nbrepeat, interactive, true, filepathname1);
    end;
