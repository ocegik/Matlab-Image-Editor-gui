function single_image_editor()
    [file, path] = uigetfile({'*.jpg;*.jpeg;*.png'}, 'Select an Image');
    if isequal(file,0)
        disp("File not exist. Exiting.");
        return;
    end

    img = imread(fullfile(path, file));
    editedImg = img;

    f = figure('Name', 'Modern Image Editor', 'NumberTitle', 'off', ...
               'Position', [100 100 1000 800], ...
               'Color', [0.15 0.15 0.15], ... 
               'Resize', 'off', ...
               'MenuBar', 'none', ...
               'ToolBar', 'none', ...
               'CloseRequestFcn', @(~,~) closeEditor());
               
    % Image display area
    hAx = axes('Parent', f, 'Position', [0.08 0.4 0.84 0.55], ...
               'Color', [0.1 0.1 0.1], ...
               'XColor', [0.3 0.3 0.3], ...
               'YColor', [0.3 0.3 0.3]);
    hImg = imshow(img, 'Parent', hAx);

    % Title
    uicontrol('Style', 'text', 'String', 'Image Enhancement Controls', ...
              'Units', 'normalized', 'Position', [0.1 0.39 0.8 0.05], ...
              'FontSize', 16, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.15 0.15 0.15], ...
              'ForegroundColor', [0.95 0.95 0.95], ...
              'HorizontalAlignment', 'center');

    yPos = 0.38;  
    step = 0.05; 

    [hBrightnessSlider, hBrightnessValue] = makeSlider('Brightness', -100, 100, 0, ...
        [0.1 yPos 0.75 0.04], [0.7 0.9 1]);
    yPos = yPos - step;

    [hContrastSlider, hContrastValue] = makeSlider('Contrast', 0.5, 2, 1, ...
        [0.1 yPos 0.75 0.04], [1 0.7 0.9]);
    yPos = yPos - step;

    [hSepiaSlider, hSepiaValue] = makeSlider('Sepia', 0, 1, 0, ...
        [0.1 yPos 0.75 0.04], [0.9 0.7 0.5]);
    yPos = yPos - step;

    [hGraySlider, hGrayValue] = makeSlider('Grayscale', 0, 1, 0, ...
        [0.1 yPos 0.75 0.04], [0.7 0.9 1]);
    yPos = yPos - step;

    [hNegativeSlider, hNegativeValue] = makeSlider('Negative', 0, 1, 0, ...
        [0.1 yPos 0.75 0.04], [1 0.6 0.6]); 

    buttonYPos = 0.08;

    uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
              'Units', 'normalized', 'Position', [0.18 buttonYPos 0.18 0.05], ...
              'FontSize', 12, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.4 0.4 0.4], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) resetImage());

    uicontrol('Style', 'pushbutton', 'String', '💾 Save', ...
              'Units', 'normalized', 'Position', [0.41 buttonYPos 0.18 0.05], ...
              'FontSize', 12, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.2 0.7 0.2], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) saveImage());

    uicontrol('Style', 'pushbutton', 'String', '❌ Close', ...
              'Units', 'normalized', 'Position', [0.64 buttonYPos 0.18 0.05], ...
              'FontSize', 12, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.8 0.2 0.2], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) closeEditor());

    uiwait(f);

    function [hSlider, hValue] = makeSlider(name, minVal, maxVal, initVal, pos, color)
        uicontrol('Style', 'text', 'String', name, ...
                  'Units', 'normalized', 'Position', [pos(1) pos(2) 0.15 pos(4)], ...
                  'FontSize', 11, 'FontWeight', 'bold', ...
                  'BackgroundColor', [0.15 0.15 0.15], ...
                  'ForegroundColor', color, ...
                  'HorizontalAlignment', 'left');

        hSlider = uicontrol('Style', 'slider', 'Min', minVal, 'Max', maxVal, 'Value', initVal, ...
            'Units', 'normalized', 'Position', [pos(1)+0.17 pos(2) 0.5 0.06], ...
            'BackgroundColor', [0.25 0.25 0.25], ...
            'SliderStep', [0.01 0.1], ...
            'Callback', @(src,~) updateImage());

        hValue = uicontrol('Style', 'text', 'String', num2str(initVal), ...
            'Units', 'normalized', 'Position', [pos(1)+0.7 pos(2) 0.08 pos(4)], ...
            'FontSize', 10, ...
            'BackgroundColor', [0.2 0.2 0.2], ...
            'ForegroundColor', [0.95 0.95 0.95], ...
            'HorizontalAlignment', 'center');
    end

    function updateImage()
        try
            % Sliders
            brightnessVal = get(hBrightnessSlider, 'Value');
            contrastVal   = get(hContrastSlider, 'Value');
            sepiaVal      = get(hSepiaSlider, 'Value');
            grayVal       = get(hGraySlider, 'Value');
            negativeVal   = get(hNegativeSlider, 'Value');

            % Update labels
            set(hBrightnessValue, 'String', sprintf('%.0f', brightnessVal));
            set(hContrastValue, 'String', sprintf('%.1f', contrastVal));
            set(hSepiaValue, 'String', sprintf('%.2f', sepiaVal));
            set(hGrayValue, 'String', sprintf('%.2f', grayVal));
            set(hNegativeValue, 'String', sprintf('%.2f', negativeVal));

            % Start from original image
            editedImg = adjustContrast(img, contrastVal);
            editedImg = adjustBrightness(editedImg, brightnessVal);

            % Apply extra effects with intensity
            if sepiaVal > 0
                editedImg = adjustSepia(editedImg, sepiaVal);
            end
            if grayVal > 0
                editedImg = adjustGrayscale(editedImg, grayVal);
            end
            if negativeVal > 0
                editedImg = adjustNegative(editedImg, negativeVal);
            end

            set(hImg, 'CData', editedImg);
        
        catch ME
            warndlg(['Update failed: ' ME.message], 'Update Error');
        end
    end



    function resetImage()
        set(hBrightnessSlider, 'Value', 0);
        set(hContrastSlider, 'Value', 1);
        set(hSepiaSlider, 'Value', 0);
        set(hGraySlider, 'Value', 0);
        set(hNegativeSlider, 'Value', 0);

        set(hBrightnessValue, 'String', '0');
        set(hContrastValue, 'String', '1.0');
        set(hSepiaValue, 'String', '0.0');
        set(hGrayValue, 'String', '0.0');
        set(hNegativeValue, 'String', '0.0');

        editedImg = img;
        set(hImg, 'CData', editedImg);
    end



    function saveImage()
        try
            % File save dialog
            [saveFile, savePath] = uiputfile({'*.jpg';'*.png'}, 'Save Edited Image As');
            if isequal(saveFile, 0)
                disp('Save cancelled.');
                return;
            end
            
            % Attempt to save the image
            imwrite(editedImg, fullfile(savePath, saveFile));
            
            % Success message
            if isvalid(f)
                msgbox('Image saved successfully!', 'Success');
            end
            
        catch saveError
            if isvalid(f)
                errordlg(['Save failed: ' saveError.message], 'Save Error');
            end
        end
    end

    function closeEditor()
        try
            % Clean close of the figure
            if isvalid(f)
                delete(f);
            end
        catch
            % Force close if normal close fails
            if ishandle(f)
                close(f, 'force');
            end
        end
    end
end
