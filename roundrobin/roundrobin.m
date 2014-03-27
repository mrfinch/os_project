function [start_t,end_t] = roundrobin()

prompt = 'How many processes do you want to enter:';            % # of processes we wish to address is stored in num, 
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
prompt = '\nEnter quantum time:';                                 % the quantum time is taken here 
q_time = input(prompt);

disp(inp);
sortrows(inp);                                               % sortrows is to sort the processes depending upon their arrival times
d = sum(inp,1);
inp
mini = min(inp);
minm = mini(1);                                               
fin = d(2)+minm;
t=1;
while d(2)~=0
    for i = 1:num                                             % depending upon the sort the processes are rather served as per their 
                                                              % arrival unlike their bursts time playing a role in their processing in terms of priority 
       if inp(i,1) > t
           t = t+1;
       else
           if inp(i,2) == 0
               continue;
           elseif inp(i,2) > q_time
               if start_t(i) == 0
                   start_t(i) = t;
               end
               inp(i,2) = inp(i,2)-q_time;
               t = t+q_time;
           else
               if start_t(i) == 0
                   start_t(i) = t;
               end
               t = t+inp(i,2);
               end_t(i) = t;
               inp(i,2) = 0;
           end    
       end    
    end
    d = sum(inp,1);
end    
t
start_t
end_t

throughput = num/t;
fprintf('Throughput %f \n',throughput);

fprintf('\nResponse time\n');
resp_t = zeros(num,1);
for i = 1:num
    resp_t(i) = start_t(i)-inp(i,1);
end
for i = 1:num
    fprintf('\nProcess: %d  Time: %d',i,resp_t(i));
end    
avg_resp = sum(resp_t)/num;
fprintf('\nAverage response Time: %f',avg_resp);
                                                              % the throughput, response time, turnaround time, waiting time and their averages shall be computed and shall be printed 
                                                              % he logic for calculation is quite visible in the code.

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

