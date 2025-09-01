function batch_process

    inputFolder = uigetdir(pwd, 'Select Folder with Images');
    if inputFolder == 0
        disp('No folder selected. Exiting.');
        return;
    end

    outputFolder = fullfile(inputFolder, 'Processed');
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    brightnessVal = 20;  
    contrastVal = 1.2;  
    applyGray = false;   
    applySepia = false; 
    applyNeg = false;    

    imgFiles = dir(fullfile(inputFolder, '*.jpg'));
    imgFiles = [imgFiles; dir(fullfile(inputFolder, '*.png'))]; 

    for k = 1:length(imgFiles)
        imgPath = fullfile(inputFolder, imgFiles(k).name);
        img = imread(imgPath);

        img = adjustContrast(img, contrastVal);
        img = adjustBrightness(img, brightnessVal);

        if applyGray
            img = adjustGrayscale(img);
        end
        if applySepia
            img = adjustSepia(img);
        end
        if applyNeg
            img = adjustNegative(img);
        end

        [~, name, ext] = fileparts(imgFiles(k).name);
        savePath = fullfile(outputFolder, [name '_processed' ext]);
        imwrite(img, savePath);
        disp(['Processed: ' imgFiles(k).name]);
    end

    disp(['All images saved in: ' outputFolder]);
end
