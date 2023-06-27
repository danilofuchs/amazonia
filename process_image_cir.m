function [floresta_km2, floresta_pct] = process_image_cir(im, area_km2)
    s = size(im);
    pixel_count = s(1) * s(2);
    pixel_area_km2 = area_km2 / pixel_count;

    figure, imshow(im), title("Imagem original");

    %% Separar camadas CIR

    nir = im(:,:,1);
    red = im(:,:,2);
    green = im(:,:,3);

    %% Ajuste de contraste em RED e GREEN
    nir = nir; % Autocontraste na NIR aumenta ruídos
    red = imadjust(red);
    green = imadjust(green);

    cir = cat(3, nir, red, green);

    figure, imshow(cir), title("Após autocontraste no RED e GREEN");

    %% Filtro gaussiano
    h = fspecial("gaussian", 6, 0.8);

    nir = imfilter(nir, h);
    red = imfilter(red, h);
    green = imfilter(green, h);

    cir = cat(3, nir, red, green);

    % figure, imshow(cir), title("Após filtro gaussiano");

    %% K-Means
    K = 3;

    % reorganiza pra passar pro k-means
    nr = size(cir,1);
    nc = size(cir,2);
    np = nr*nc;
    
    cir_cols = reshape(cir, np, 3);
    cir_cols = double(cir_cols);
    
    % K-means no CIR
    labeled = kmeans(cir_cols, K, 'Distance', 'sqeuclidean');
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

