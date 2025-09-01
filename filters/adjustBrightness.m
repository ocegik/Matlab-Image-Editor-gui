function output = adjustBrightness(img, value)
    
    img = im2double(img);           
    output = img + value/100;       
    output = min(max(output,0),1); 
end
