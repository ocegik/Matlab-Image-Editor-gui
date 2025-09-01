function output = adjustSepia(img, intensity)
    if nargin < 2
        intensity = 1; % default full sepia
    end
    if size(img,3) ~= 3
        img = repmat(img,[1 1 3]);  % grayscale → RGB
    end
    img = im2double(img);
    sepiaFilter = [0.393 0.769 0.189;
                   0.349 0.686 0.168;
                   0.272 0.534 0.131];
    sepiaImg = img;
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            rgb = squeeze(img(i,j,:));
            rgb = sepiaFilter * rgb;
            sepiaImg(i,j,:) = min(rgb,1);
        end
    end
    output = (1-intensity)*img + intensity*sepiaImg;
end