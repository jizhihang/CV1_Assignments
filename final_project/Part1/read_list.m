function [ file_list ] = read_list(path)
   list = {};
   file = fopen(path);
   line = fgetl(file);
   while ischar(line)
      list{end+1, 1} = strcat(strcat('Caltech4/ImageData/',line),'.jpg');
      line = fgetl(file);
   end
   file_list = list;
   fclose(file);
end

