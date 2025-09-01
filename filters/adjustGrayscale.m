function output = adjustGrayscale(img, intensity)
    if nargin < 2
        intensity = 1; % default full grayscale if intensity not provided
    end
    if size(img,3) == 3  % RGB check
        gray = rgb2gray(img);
        gray = repmat(gray,[1 1 3]);  % convert to RGB
        img = im2double(img);
        output = (1-intensity)*img + intensity*gray;
    else
        output = img;  % already grayscale
    end
end