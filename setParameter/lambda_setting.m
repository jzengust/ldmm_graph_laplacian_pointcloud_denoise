function lambda_b = lambda_setting(noise_level)
% 4,7,12 for 0.02,0.03,0.04
switch noise_level
    case '0.02'
        lambda_b = 4;
    case '0.03'
        lambda_b = 7;
    case '0.04'
        lambda_b = 12;
    otherwise
        disp('lambda need tuning')
        lambda_b = 7;
end
end