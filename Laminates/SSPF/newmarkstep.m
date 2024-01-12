function [newu, newudot, newuddot] = newmarkstep(u, udot, uddot, K, M, f, dt)
%NEWMARK Summary of this function goes here
%   Detailed explanation goes here
    beta1 = 1.5;
    beta2 = 20;
    newuddot = (f - K * (u + udot * dt + 0.5*dt^2*uddot*(1-beta2))) / (M + 0.5*dt^2*beta2*K);
    
    newu = u + udot * dt + 0.5 * dt^2 * (uddot * (1-beta2) + beta2 * newuddot);
    newudot = udot + dt * (uddot * (1-beta1) + beta1 * newuddot);
end

