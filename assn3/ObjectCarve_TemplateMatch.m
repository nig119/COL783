function out = ObjectCarve_TemplateMatch(Icomplete,Ipart)
position = match_template(Icomplete, Ipart);

out = SeamCarveMultiple(Icomplete,position);
end

