function main()
    
    choice = questdlg('Do you want to edit a single image or batch process a folder?', ...
                      'Select Mode', ...
                      'Single Image','Batch Folder','Single Image');

    switch choice
        case 'Single Image'
            single_image_editor();
        case 'Batch Folder'
            batch_process();
        otherwise
            disp('No selection made. Exiting.');
    end
end