function image_editor

    [file, path] = uigetfile({'*.jpg;*.jpeg;*.png'}, 'Select an Image');
    if isequal(file,0)
        disp("File not exist.");
        return;
    end

    img = imgread(fullfile(path, file));
    editedImg = img;

    f = figure('Name', 'MATLAB Image Editor', 'Number Title', 'off',...'Position', [200 200 800 600]);

    hAx = axes('Parent',f,'Position',[0.1 0.3 0.8 0.65]);
    hImg = imshow(img, 'Parent', hAx);

    uicontrol('Style','slider','Min',-100,'Max',100,'Value',0,...
        'Units','normalized','Position',[0.1 0.2 0.7 0.04],...
        'Callback', @(src,~) updateImage());

    uicontrol('Style','slider','Min',0.5,'Max',2,'Value',1,...
        'Units','normalized','Position',[0.1 0.15 0.7 0.04],...
        'Callback', @(src,~) updateImage());

    uicontrol('Style','pushbutton','String','Save Image',...
        'Units','normalized','Position',[0.4 0.05 0.2 0.05],...
        'Callback', @(~,~) saveImage());
    
    function updateImage()
        % Get slider values
        sliders = findobj(f,'Style','slider');
        contrastVal = get(sliders(1),'Value');
        brightnessVal = get(sliders(2),'Value');

        % Apply adjustments using helper functions
        editedImg = adjustContrast(img, contrastVal);
        editedImg = adjustBrightness(editedImg, brightnessVal);

        % Update displayed image
        set(hImg,'CData',editedImg);
    end

    function saveImage()
        [saveFile, savePath] = uiputfile({'*.jpg';'*.png'}, 'Save Edited Image As');
        if isequal(saveFile,0)
            disp('Save cancelled.');
            return;
        end
        imwrite(editedImg, fullfile(savePath, saveFile));
        msgbox('Image saved successfully!','Success');
    end
end
