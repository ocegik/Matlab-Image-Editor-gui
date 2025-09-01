% Add the filters folder so all filter functions are visible
addpath('filters');

% Ask user whether to edit a single image or batch process a folder
choice = questdlg('Do you want to edit a single image or batch process a folder?', ...
                  'Select Mode', ...
                  'Single Image','Batch Folder','Single Image');

switch choice
    case 'Single Image'
        single_image_editor();  % Call your single image editor script/function
    case 'Batch Folder'
        batch_process();        % Call your batch processing script/function
    otherwise
        disp('No selection made. Exiting.');
end
