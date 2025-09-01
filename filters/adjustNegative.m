function output = adjustNegative(img, intensity)
    if nargin < 2
        intensity = 1; % default full negative
    end
    img = im2double(img);
    output = (1-intensity)*img + intensity*(1-img);
end
