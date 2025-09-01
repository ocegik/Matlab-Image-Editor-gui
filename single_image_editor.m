function single_image_editor()
    [file, path] = uigetfile({'*.jpg;*.jpeg;*.png'}, 'Select an Image');
    if isequal(file,0)
        disp("File not exist. Exiting.");
        return;
    end

    img = imread(fullfile(path, file));
    editedImg = img;

    f = figure('Name', 'Modern Image Editor', 'NumberTitle', 'off', ...
               'Position', [200 200 900 700], ...
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
              'Units', 'normalized', 'Position', [0.1 0.32 0.8 0.05], ...
              'FontSize', 14, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.15 0.15 0.15], ...
              'ForegroundColor', [0.9 0.9 0.9], ...
              'HorizontalAlignment', 'center');

    % Brightness label
    uicontrol('Style', 'text', 'String', 'Brightness', ...
              'Units', 'normalized', 'Position', [0.1 0.26 0.15 0.03], ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.15 0.15 0.15], ...
              'ForegroundColor', [0.7 0.9 1], ...
              'HorizontalAlignment', 'left');

    % Brightness slider - store handle for easy access
    hBrightnessSlider = uicontrol('Style', 'slider', 'Min', -100, 'Max', 100, 'Value', 0, ...
        'Units', 'normalized', 'Position', [0.27 0.26 0.5 0.03], ...
        'BackgroundColor', [0.25 0.25 0.25], ...
        'ForegroundColor', [0.7 0.9 1], ...
        'Tag', 'brightnessSlider', ...
        'Callback', @(src,~) updateImage());

    % Brightness value display - store handle for updates
    hBrightnessValue = uicontrol('Style', 'text', 'String', '0', ...
                               'Units', 'normalized', 'Position', [0.78 0.26 0.08 0.03], ...
                               'FontSize', 10, ...
                               'BackgroundColor', [0.2 0.2 0.2], ...
                               'ForegroundColor', [0.9 0.9 0.9], ...
                               'HorizontalAlignment', 'center', ...
                               'Tag', 'brightnessValue');
    
    % Contrast label
    uicontrol('Style', 'text', 'String', 'Contrast', ...
              'Units', 'normalized', 'Position', [0.1 0.21 0.15 0.03], ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.15 0.15 0.15], ...
              'ForegroundColor', [1 0.7 0.9], ...
              'HorizontalAlignment', 'left');

    % Contrast slider - store handle for easy access
    hContrastSlider = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, ...
        'Units', 'normalized', 'Position', [0.27 0.21 0.5 0.03], ...
        'BackgroundColor', [0.25 0.25 0.25], ...
        'ForegroundColor', [1 0.7 0.9], ...
        'Tag', 'contrastSlider', ...
        'Callback', @(src,~) updateImage());

    % Contrast value display - store handle for updates
    hContrastValue = uicontrol('Style', 'text', 'String', '1.0', ...
                            'Units', 'normalized', 'Position', [0.78 0.21 0.08 0.03], ...
                            'FontSize', 10, ...
                            'BackgroundColor', [0.2 0.2 0.2], ...
                            'ForegroundColor', [0.9 0.9 0.9], ...
                            'HorizontalAlignment', 'center', ...
                            'Tag', 'contrastValue');

    % Control buttons
    uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
              'Units', 'normalized', 'Position', [0.2 0.1 0.15 0.06], ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.4 0.4 0.4], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) resetImage());

    uicontrol('Style', 'pushbutton', 'String', '💾 Save Image', ...
              'Units', 'normalized', 'Position', [0.425 0.1 0.15 0.06], ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.2 0.7 0.2], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) saveImage());

    uicontrol('Style', 'pushbutton', 'String', '❌ Close', ...
              'Units', 'normalized', 'Position', [0.65 0.1 0.15 0.06], ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.8 0.2 0.2], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) closeEditor());

    % Progress/status panel
    hProgressPanel = uipanel('Parent', f, ...
                           'Units', 'normalized', ...
                           'Position', [0.1 0.04 0.8 0.02], ...
                           'BackgroundColor', [0.1 0.1 0.1], ...
                           'BorderType', 'line', ...
                           'HighlightColor', [0.3 0.3 0.3]);

    % Wait for figure to close
    uiwait(f);

    function updateImage()
        try
            % Safely get slider values using stored handles
            if isvalid(hBrightnessSlider) && isvalid(hContrastSlider)
                brightnessVal = get(hBrightnessSlider, 'Value');
                contrastVal = get(hContrastSlider, 'Value');
                
                % Update value displays if they still exist
                if isvalid(hBrightnessValue)
                    set(hBrightnessValue, 'String', sprintf('%.0f', brightnessVal));
                end
                if isvalid(hContrastValue)
                    set(hContrastValue, 'String', sprintf('%.1f', contrastVal));
                end
                
                % Apply image adjustments with error handling
                try
                    editedImg = adjustContrast(img, contrastVal);
                    editedImg = adjustBrightness(editedImg, brightnessVal);
                    
                    % Update image display if it still exists
                    if isvalid(hImg)
                        set(hImg, 'CData', editedImg);
                    end
                    
                    % Visual feedback
                    if isvalid(hProgressPanel)
                        set(hProgressPanel, 'BackgroundColor', [0.2 0.6 0.2]);
                        drawnow;
                        pause(0.05);
                        if isvalid(hProgressPanel)
                            set(hProgressPanel, 'BackgroundColor', [0.1 0.1 0.1]);
                        end
                    end
                    
                catch adjustError
                    % Handle image processing errors
                    if isvalid(f)
                        warndlg(['Image adjustment failed: ' adjustError.message], 'Processing Warning');
                    end
                end
            end
        catch ME
            % Handle any other errors in updateImage
            if isvalid(f)
                warndlg(['Update failed: ' ME.message], 'Update Error');
            end
        end
    end

    function resetImage()
        try
            % Reset sliders to default values if they exist
            if isvalid(hBrightnessSlider)
                set(hBrightnessSlider, 'Value', 0);
            end
            if isvalid(hContrastSlider)
                set(hContrastSlider, 'Value', 1);
            end
            
            % Update value displays if they exist
            if isvalid(hBrightnessValue)
                set(hBrightnessValue, 'String', '0');
            end
            if isvalid(hContrastValue)
                set(hContrastValue, 'String', '1.0');
            end
            
            % Reset image to original
            editedImg = img;
            if isvalid(hImg)
                set(hImg, 'CData', editedImg);
            end
            
            % Visual feedback
            if isvalid(hProgressPanel)
                set(hProgressPanel, 'BackgroundColor', [0.6 0.6 0.2]);
                drawnow;
                pause(0.1);
                if isvalid(hProgressPanel)
                    set(hProgressPanel, 'BackgroundColor', [0.1 0.1 0.1]);
                end
            end
            
        catch ME
            if isvalid(f)
                warndlg(['Reset failed: ' ME.message], 'Reset Error');
            end
        end
    end

    function saveImage()
        try
            % File save dialog
            [saveFile, savePath] = uiputfile({'*.jpg';'*.png'}, 'Save Edited Image As');
            if isequal(saveFile, 0)
                disp('Save cancelled.');
                return;
            end
            
            % Visual feedback during save
            if isvalid(hProgressPanel)
                set(hProgressPanel, 'BackgroundColor', [0.2 0.2 0.8]);
                drawnow;
            end
            
            % Attempt to save the image
            imwrite(editedImg, fullfile(savePath, saveFile));
            
            % Success feedback
            if isvalid(hProgressPanel)
                set(hProgressPanel, 'BackgroundColor', [0.2 0.8 0.2]);
                drawnow;
                pause(0.2);
                if isvalid(hProgressPanel)
                    set(hProgressPanel, 'BackgroundColor', [0.1 0.1 0.1]);
                end
            end
            
            % Success message
            if isvalid(f)
                msgbox('Image saved successfully!', 'Success');
            end
            
        catch saveError
            % Error feedback
            if isvalid(hProgressPanel)
                set(hProgressPanel, 'BackgroundColor', [0.8 0.2 0.2]);
                drawnow;
                pause(0.2);
                if isvalid(hProgressPanel)
                    set(hProgressPanel, 'BackgroundColor', [0.1 0.1 0.1]);
                end
            end
            
            % Error message
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
