%@author: Madeline Shao
try
    %noise=darkness_range*randn(size(mask)./block_size); %or apply mask after noise
    %noise=imresize(noise,block_size,'nearest'); %nearest neighbor interpolation
    %repmat(__,[one time on x,y, and across all 3 layers]);
    %imshow() %shows image if u wanna check ur code
    clear all

    %% Load Screen

    Screen('Preference', 'SkipSyncTests', 1);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
    [window, rect] = Screen('OpenWindow', 0); % opening the screen
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos

    HideCursor();
    window_w = rect(3); % defining size of screen
    window_h = rect(4);

    x = window_w/2;
    y = window_h/2;

    %% Orange Mask
    cd('Stimuli');
    mask = imread('mask.png'); % mask for transparency
    mask = mask(:,:,1); %use first layer % added

    %% Reading / Loading in Oranges with Noise
    % Create noise with large blocks
    block_size = 31;
    % Define random darkness values of each block
    darkness_range = 50;

        tid = zeros(1,10);
    for f = 1:10;
        tmp_bmp = imread([num2str(f) '.png']); % read 10 photos



        % look at powerpoint for hints! 
        noise=darkness_range*randn(round(size(mask)./block_size));
%         imshow(noise);

        % Noise patch should have the same size as each stimulus
        noise=imresize(noise,block_size,'nearest'); 
%          imshow(noise);
        % Add noise values to stimulus matrix
        noise=repmat(noise,1,1,3);
        imshow(noise);
        tmp_bmp=double(tmp_bmp);
        tmp_bmp = tmp_bmp+noise;

        tmp_bmp(:,:,4) = mask;
        tid(f) = Screen('MakeTexture', window, uint8(tmp_bmp));
    end

    w_img = size(tmp_bmp, 2) * 0.5; % width of pictures
    h_img = size(tmp_bmp, 1) * 0.5; % height of pictures

    %% Displaying Orange with Noise

    for i = 1:10
        Screen('DrawTexture', window, tid(i), [], ...
            [(x-w_img) (y-h_img) (x+w_img) (y +h_img)]);

        Screen('Flip',window); % display
        WaitSecs(1); %timing of display

        Screen('Flip',window); % blank
        WaitSecs(1); %timing of blank
    end

    Screen('CloseAll');
catch
    Screen('CloseAll');
    rethrow(lasterror)
end
