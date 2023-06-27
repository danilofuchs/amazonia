function [floresta_km2, floresta_pct] = process_image_ndvi(im, area_km2)
    im = im2double(im);

    s = size(im);
    pixel_count = s(1) * s(2);
    pixel_area_km2 = area_km2 / pixel_count;

    figure, imshow(im), title("Imagem original");
    
    %% NDVI
    nir = im(:,:,1);
    red = im(:,:,2);
    
    ndvi = (nir - red) ./ (nir + red);

    %% Autocontraste
    ndvi = imadjust(ndvi);

    figure, imshow(ndvi);
    % , title("Normalized Difference Vegetation Index (NDVI)");
    
    %% Filtro gaussiano
    h = fspecial("gaussian", 6, 0.8);
    
    ndvi = imfilter(ndvi, h);
    
    % figure, imshow(ndvi), title("Após filtro gaussiano");
    
    %% K-Means
    K = 3;

    % reorganiza pra passar pro k-means
    nr = size(ndvi,1);
    nc = size(ndvi,2);
    np = nr*nc;

    ndvi_cols = reshape(ndvi, np, 1);
    
    % K-means
    labeled = kmeans(ndvi_cols, K, 'Distance', 'sqeuclidean');
    labeled = reshape(labeled, nr, nc);
    labeled_rgb = labeloverlay(im, labeled, "Transparency", 0.8, "Colormap", "jet");

    figure, imshow(labeled_rgb), title('Imagem segmentada. Clique em uma área de floresta')
    point = drawpoint('Color', "green");
    point.Label = "Floresta";


    y = floor(point.Position(2));
    x = floor(point.Position(1));

    delete(point)

    label_floresta = labeled(y, x);

    %% Calcular area
    areas = zeros(K);
    for label = 1:K
        areas(label) = sum(labeled == label, "all") * pixel_area_km2;
    end
    
    floresta_km2 = areas(label_floresta);
    floresta_pct = (floresta_km2 / area_km2) * 100;
end

