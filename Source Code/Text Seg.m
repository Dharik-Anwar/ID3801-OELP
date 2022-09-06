for i = 1:6
    [r,g,b,gs,l,a1,b1,h,s,v] = Init(i, false);
    img = gs;
    num = 7;
    
    filt = myfilter("rang", img, num);
    filtBW = ~imbinarize(filt);
    imgBW = img < 240 & img > 80;
    mask = filtBW - imgBW;
%     
    SE = strel("disk", 4);
    mask = imopen(~mask,SE);
    mask = ~mask;
%     
    mask = bwareaopen(mask,10000);
    mask = ~mask;
    mask = imfill(mask,"holes");
    mask = imclearborder(mask);
    
    img = cat(3,r,g,b);
    img1 = imoverlay(img,~mask,"k");
    figure
    imshowpair(img1,img,"montage")
%     imshow(mask)
end

function res = myfilter(filt, img, num)
    nhood = ones(num);
    if filt == "rang"
       res = rangefilt(img, nhood);
    elseif filt == "std"
        res = stdfilt(img, nhood);
    elseif filt == "ent"
        res = entropyfilt(img, nhood);
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