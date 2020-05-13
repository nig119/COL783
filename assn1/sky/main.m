
clc; clear all;

GRAPH = false;
SAVE = false;
%% load images

gtarget = {};
ctarget = {};
gsource = {};
csource = {};

csource.image = im2double(imread('source.jpg'));
ctarget.image = im2double(imread('target.jpg'));

gsource.image = im2double(rgb2gray(csource.image));
gtarget.image = im2double(rgb2gray(ctarget.image));

%% to LAB color space
csource.lab = rgb2lab(csource.image);
gsource.lab = gsource.image;
gtarget.lab = gtarget.image;

%% map luminance to target luminance
csource.luminance = luminance_remap(csource.lab, gtarget.lab);
gsource.luminance = luminance_remap(gsource.lab, gtarget.lab);
gtarget.luminance = gtarget.lab;
% pixel values are luminance

transferred = image_colorization(gtarget, csource, GRAPH);
imshow(lab2rgb(transferred));