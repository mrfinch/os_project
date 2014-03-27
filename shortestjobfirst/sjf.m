function [start_t,end_t] = sjf()

prompt = 'How many processes do you want to enter:';   % # of processes we wish to address is stored in num, 
                                                       % followed by passing its arrival time and burst time
                                                    
num = input(prompt);
inp = zeros(num,2);
start_t = zeros(num,1);
end_t = zeros(num,1);
for i = 1:num
    prompt = '\nEnter arrival time of process:';
    x = input(prompt);
    prompt = '\nEnter burst time of process:';
    y = input(prompt);
    inp(i,1)=x;
    inp(i,2)=y;
end
prompt = '\nEnter quantum time:';                   % the quantum time is taken here 
q_time = input(prompt);   
    
disp('Input:')
disp(inp);
sortrows(inp);                                      % sortrows is to sort the processes depending upon their arrival times
d = sum(inp,1);

mini = min(inp);
minm = mini(1);
fin = d(2)+minm;
t=1;

while d(2)~=0
    %inp
    %t
    while t <= fin+50                               % if the index passed(see the last comment of the code) has no process to serve it will  
        i = short_time(inp,t,num);                  % return -1 else following the pre-emption policy the burst time will be reduced by the qunta of time
        if i == -1                                  % and the process will have its burst time updated and will again be processed depending upon the short_time
            t = t+1;
            continue;
        end    
        if inp(i,2) > q_time
            if start_t(i)==0
                start_t(i) = t;
            end
            inp(i,2) = inp(i,2)-q_time;
            t = t+q_time;
        else
            if start_t(i)==0
                start_t(i) = t;
            end
            t = t+inp(i,2);
            end_t(i) = t;
            inp(i,2) = 0;
        end    
    end
    d = sum(inp,1);
end
start_t
end_t
throughput = num/t;
fprintf('Throughput %f \n',throughput);                       % the throughput, response time, turnaround time, waiting time and their averages shall be computed and shall be printed 

fprintf('\nResponse time\n');                                 % the logic for calculation is quite visible in the code.
resp_t = zeros(num,1);
for i = 1:num
    resp_t(i) = start_t(i)-inp(i,1);
end
for i = 1:num
    fprintf('\nProcess: %d  Time: %d',i,resp_t(i));
end    
avg_resp = sum(resp_t)/num;
fprintf('\nAverage response Time: %f',avg_resp);


fprintf('\nTurnaround Time\n')
turn_t = zeros(num,1);
for i=1:num
    turn_t(i) = end_t(i) - inp(i,1);
end
for i = 1:num
    fprintf('\nProcess: %d  Time: %d',i,turn_t(i));
end    
avg_turn = sum(turn_t)/num;
fprintf('\nAverage turnaround Time: %f',avg_turn);

fprintf('\nWaiting time\n')
wait_t = zeros(num,1);
for i=1:num
    wait_t(i) = end_t(i) - start_t(i)-inp(i,2);
end
for i = 1:num
    fprintf('\nProcess: %d  Time: %d',i,wait_t(i));
end
avg_wait = sum(wait_t)/num;
fprintf('\nAverage waiting Time: %f',avg_wait);


end


function t = short_time(x,ti,num)                             % the short_time method takes in all the inputs and depending upon the current time ti 
min = 999;                                                    % and all the arrived processes till ti passes an index t of the process with shortest burst time.
for i = 1:num
    if x(i,2)>0 && x(i,2)<min && x(i,1)<=ti
       min = x(i,2);
       t=i;
    end    
end
if min == 999
    t = -1;
end
end



