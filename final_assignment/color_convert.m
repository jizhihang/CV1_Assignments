function [ outIm ] = color_convert(inIm, type)

switch type
    case 'RGB2hsv'
        outIm = rgb2hsv(inIm);
    case 'RGB2opponent'
        % Get individual channels
        R = inIm(:,:,1);
        G = inIm(:,:,2);
        B = inIm(:,:,3);
        
        % Opponent channels
        O1 = (R - G) ./ sqrt(2.);
        O2 = (R + G - 2 * B) ./ sqrt(6.);
        O3 = (R + G + B) ./ sqrt(3.);
        
        % Set new channels
        outIm(:,:,1) = O1;
        outIm(:,:,2) = O2;
        outIm(:,:,3) = O3;
    case 'RGB2rgb'
        norm = inIm(:,:,1) + inIm(:,:,2) + inIm(:,:,3);
        
        % Normalize
        outIm(:,:,1) = inIm(:,:,1) ./ norm;
        outIm(:,:,2) = inIm(:,:,2) ./ norm;
        outIm(:,:,3) = inIm(:,:,3) ./ norm;
    otherwise
        throw(MException('SIFT:COLOR', 'Color must be RGB2hsv, RGB2opponent or RGB2rgb'));
end

