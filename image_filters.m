function output = adjustBrightness(img, value)
    
    img = im2double(img);           
    output = img + value/100;       
    output = min(max(output,0),1); 
end

function output = adjustContrast(img, factor)
    
    img = im2double(img);           
    output = 0.5 + factor*(img - 0.5); 
    output = min(max(output,0),1);      
end

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

function output = adjustNegative(img, intensity)
    if nargin < 2
        intensity = 1; % default full negative
    end
    img = im2double(img);
    output = (1-intensity)*img + intensity*(1-img);
end
