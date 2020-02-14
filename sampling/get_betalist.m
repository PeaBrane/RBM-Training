function list = get_betalist(w)

n = size(w,1); m = size(w,2);
scale = mean(abs(w),[1 2]);

list = [0.01 (log(n)+log(m))/2]/scale;

end