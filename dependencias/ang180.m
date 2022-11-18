function Y = ang180(X);
% ANG180   Unwraps the input angle to an angle between -180 and 180 degrees.
%
%   Pascal de Theije, v1.0, 24 February 1999
%   Copyright (c) 2003, TNO-FEL
%   All Rights Reserved
Y = mod(X-(1e-10)-180,360) - 180 + (1e-10);
                         % The term 1e-10 is to set an input of -180 to 180.