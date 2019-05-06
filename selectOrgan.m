function organ = selectOrgan()
%get list of organs 
global organs;
addpath('speech2text');

% Create speech client for speech2text organbox 
speechObject = speechClient('Google','languageCode','en-US');
sample_freq = 8192*2;
sample_time = 3; %seconds to record
organ = "";
isSelected = false; 
while(~isSelected)
    % prompt for organ
    % TODO speach @ us and/or popup
    disp("Please specify a organ");
    input('Press enter to start recording');

    % user responds
    recorder = audiorecorder(sample_freq,8,1);
    recordblocking(recorder,sample_time);
    disp("Recording finished. Processing...");
    % Get the speech samples
    y = getaudiodata(recorder);

    % Call the |speech2text| function and pass the |speechClient| object
    % with |y| and |fs|
    %tableOut = speech2text(speechObject,y,fs)
    tableOut = speech2text(speechObject, y, sample_freq, 'HTTPTimeOut', 25);
    
    % Obtain the word detected
    word = tableOut{1,1}; 
    
    if (strcmp(tableOut.Properties.VariableNames{1}, 'status')) 
        fprintf('Error processing recording: %s\n\t%s\n', word{1}, tableOut{1,2}{1}); 
        continue;
    elseif (0 == strcmp(tableOut.Properties.VariableNames{1},'transcript'))
        disp('Unknown error. Please try again');
        continue;
    end
    
    if (contains(word, ' '))
       disp('More than one word detected. Please try again');
       continue;
    end

    % Obtain the confidence level 
    conf = tableOut{1,2};

    if (conf < 0.5)
       fprintf('Not reliable recording. Try again. Confidence: %i\n', conf);
       continue;
    end
    
    for i=1:size(organs,1)
        if (strcmp(organs(i), word))
            isSelected = true;
            disp('organ found');
            organ = organs(i);
            break;
        end
    end
    % organ not found
    if (~isSelected)
        fprintf('organ %s not found. Please try again\n', word);
    end
end %end while

end %end function