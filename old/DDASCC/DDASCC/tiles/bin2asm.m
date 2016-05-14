close all

x = dir('bins\*.bin');
nfiles = size(x,1);

unc_siz = zeros(nfiles,1);

for i=1:nfiles
    i
    disp (x(i).name);
    name = [ 'bins\' x(i).name];
    
    fid = fopen(name,'rb');
    data = fread(fid,inf,'uint8');
    fclose(fid);
    
%    data = data(101:end);
    num = size(data,1);

    unc_siz(i) = num;
    
    compr = 'M';

    if compr~=' '
     fid = fopen('temp.bin','wb');    
     fwrite(fid,data,'uint8');    
     fclose(fid);    
     
     if (compr=='P')
         compressor = 'Pletter';
         !C:\HT-Z80\pletter5c1\pletter.exe temp.bin temp.cmp
     else
         compressor = 'Mizer';
         !C:\HT-Z80\msxdev08\Mizer\MSX-O-Mizer.exe -r temp.bin temp.cmp
     end
    
     fid = fopen('temp.cmp','rb');
     [data,num] = fread(fid,inf,'uint8');
     fclose(fid);
 
     name = [ x(i).name '.cmp'];
     fid = fopen(name ,'wb');
     fwrite(fid,data,'uint8');
     fclose(fid);
    end
    
    name = x(i).name ;
    name((end-2):end)='asm';
    fid = fopen(name ,'wb');
 
    if compr~=' ' 	
        fwrite(fid,['   ;  ' x(i).name ', compressed by ' compressor 13 10 ],'char');
%         fwrite(fid,'   dw ' ,'char');
%         outhex(fid,unc_siz(i))	
%         fwrite(fid,['   ;  original size ' 13 10 ],'char');
    else
        fwrite(fid,['   ;  ' x(i).name ', uncompressed ' 13 10 ],'char');    
    end
    
    nummperlin = 16;
    
    succ = 1;
    
    while ((num/nummperlin)>=1)
            
        fwrite(fid,'   db ','char');
        for h=1:(nummperlin-1)
            outhex(fid,data(succ));                            
            fwrite(fid,',');
            succ = succ + 1;
        end
        outhex(fid,data(succ));
        succ = succ + 1;
        fwrite(fid,[13 10]);
            
        num = num - nummperlin;
    end

    if (num>0)
        fwrite(fid,'   db ','char');
        for h=1:(num-1)
            outhex(fid,data(succ));                            
            fwrite(fid,',');
            succ = succ + 1;
        end
        outhex(fid,data(succ));
        succ = succ + 1;
        fwrite(fid,[13 10]);
    end


    fclose(fid);
end

%!del temp.*
%!del *.cmp
