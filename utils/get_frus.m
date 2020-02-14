function f = get_frus(a,b,w,v0,h0)

E = a*v0.' + b*h0.' + v0*w*h0.';
mag = sum(abs(a)) + sum(abs(b)) + sum(abs(w(:)));
f = (mag-E)/E/2;

end