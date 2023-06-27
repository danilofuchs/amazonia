clc; clear; close all;

% Medidor de desmatamento da Amazônia
% https://www.planet.com/explorer/?s=UNS6fwFDRaOTUSdpRXroiQ
% Área de interesse retangular: [-63.341818,-8.87654],[-62.765656,-8.87654],[-62.765656,-8.514369],[-63.341818,-8.514369],[-63.341818,-8.87654]
% Resolução: 37.03 m/px
% Área total: 1.243 km2

im_old = imread("candeias_junho_2017_cir.png");
im_new = imread("candeias_nov_2022_cir.png");

area_km2 = 1.243;


fprintf("================ NDVI ================\n")

[area_old, pct_old] = process_image_ndvi(im_old, area_km2);
[area_new, pct_new] = process_image_ndvi(im_new, area_km2);

fprintf("Área analisada = %2.4f km^2 \t(%.2f%%)\n", area_km2, 100);
fprintf("--------------------------------------\n");
fprintf("Floresta\n");
fprintf("--------------------------------------\n");
fprintf("Antigo  : Área = %2.4f km^2 \t(%.2f%%)\n", area_old, pct_old);
fprintf("Novo    : Área = %2.4f km^2 \t(%.2f%%)\n", area_new, pct_new);
fprintf("Diff    : Área = %2.4f km^2 \t(%.2f%%)\n", area_new - area_old, pct_new - pct_old);


fprintf("\n")
fprintf("================ CIR =================\n")

[area_old, pct_old] = process_image_cir(im_old, area_km2);
[area_new, pct_new] = process_image_cir(im_new, area_km2);

fprintf("Área analisada = %2.4f km^2 \t(%.2f%%)\n", area_km2, 100);
fprintf("--------------------------------------\n");
fprintf("Floresta\n");
fprintf("--------------------------------------\n");
fprintf("Antigo  : Área = %2.4f km^2 \t(%.2f%%)\n", area_old, pct_old);
fprintf("Novo    : Área = %2.4f km^2 \t(%.2f%%)\n", area_new, pct_new);
fprintf("Diff    : Área = %2.4f km^2 \t(%.2f%%)\n", area_new - area_old, pct_new - pct_old);

