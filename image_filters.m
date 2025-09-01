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

function output = applyGrayscale(img)
   
    if size(img,3) == 3  % check if RGB
        output = rgb2gray(img);
    else
        output = img;    % already grayscale
    end
end

function output = applySepia(img)
    
    if size(img,3) ~= 3
        img = repmat(img,[1 1 3]);  % convert grayscale to RGB
    end
    img = im2double(img);
    sepiaFilter = [0.393 0.769 0.189;
                   0.349 0.686 0.168;
                   0.272 0.534 0.131];
    output = img;
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            rgb = squeeze(img(i,j,:));
            rgb = sepiaFilter * rgb;
            output(i,j,:) = min(rgb,1);
        end
    end
end

function output = applyNegative(img)
   
    img = im2double(img);
    output = 1 - img;
end
