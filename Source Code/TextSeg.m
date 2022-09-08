for i = 1:6
    [r,g,b,gs,l,a1,b1,h,s,v] = Init(i, false);  %Loading the images
    img = gs;   %Loading the grayscale image
    num = 3;    %Setting the nhood for filter
    
    filt = myfilter("rang", img, num);  %Calling the range filter
    filtBW = ~imbinarize(filt); %Binarizing the filter
    imgBW = img < 250 & img > 80;
    mask = filtBW - imgBW;  %Making the mask
%     
    SE = strel("disk", 4);  %Strutural Element
    mask = imopen(~mask,SE);    %Opening the mask
%     mask = ~mask;
%     
    mask = bwareaopen(mask,10000);  %Crearing the noise in the background
%     mask = ~mask;
    mask = imfill(mask,"holes");    %Filling the holes
%     mask = imclearborder(mask); %Clearing the border
    
    img = cat(3,r,g,b); %Making an RGB image
    img1 = imoverlay(img,~mask,"k");    %Overlay the mask in the image
    figure
    imshowpair(img1,img,"montage")
%     imshow(mask)
end

function res = myfilter(filt, img, num)
    nhood = ones(num);
    if filt == "rang"
       res = rangefilt(img, nhood);
    elseif filt == "std"
        res = rescale(stdfilt(img, nhood));
    elseif filt == "ent"
        res = rescale(entropyfilt(img, nhood));
    end
end

function [r,g,b,gs,l,a1,b1,h,s,v] = Init(num, bool)
    rgb = imread("Images data\Banginapalli\Image_"+num+".jpg");
    gs = rgb2gray(rgb);
    lab = rgb2lab(rgb);
    hsv = rgb2hsv(rgb);
    
    [r,g,b] = imsplit(rgb);
    [l,a1,b1] = imsplit(lab);
    [h,s,v] = imsplit(hsv);
    
    l = rescale(l);
    a1 = rescale(a1);
    b1 = rescale(b1);

    h = rescale(h);
    s = rescale(s);
    v = rescale(v);


    if bool
        montage({r,g,b,l,a1,b1,h,s,v},"Size",[3,3])
    end
end