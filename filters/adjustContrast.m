function output = adjustContrast(img, factor)
    
    img = im2double(img);           
    output = 0.5 + factor*(img - 0.5); 
    output = min(max(output,0),1);      
end
