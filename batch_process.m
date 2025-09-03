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

    [brightnessVal, contrastVal, sepiaVal, grayVal, negativeVal] = filter_settings();

    imgFiles = [dir(fullfile(inputFolder, '*.jpg')); dir(fullfile(inputFolder, '*.png'))];

    for k = 1:length(imgFiles)
        imgPath = fullfile(inputFolder, imgFiles(k).name);
        img = imread(imgPath);

        % Apply effects with chosen params
        img = adjustContrast(img, contrastVal);
        img = adjustBrightness(img, brightnessVal);

        if sepiaVal > 0
            img = adjustSepia(img, sepiaVal);
        end
        if grayVal > 0
            img = adjustGrayscale(img, grayVal);
        end
        if negativeVal > 0
            img = adjustNegative(img, negativeVal);
        end

    [~, name, ext] = fileparts(imgFiles(k).name);
        savePath = fullfile(outputFolder, [name '_processed' ext]);
        imwrite(img, savePath);
        disp(['Processed: ' imgFiles(k).name]);
    end

    disp(['All images saved in: ' outputFolder]);
end
