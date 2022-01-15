%for couples put their ratings at 100 for each other
%all other ratings 0 to 5 with 5 being best and 0 being active dislike
%function table_planner
clear;
disp('Instructions');
disp('for couples put their ratings at 100 for each other');
disp('all other ratings 0 to 5 with 5 being best and 0 being active dislike');
disp('Excel inputs must be in the form shown below. Please ensure there is no other data in the sheet')
example_image='C:\Users\micha\OneDrive\Documents\Uni stuff\Aerospace\excel_example.jpg';
imshow(example_image);
input_method=input('Choose your input method. Enter 1 to import an excel sheet or 2 for direct input ');
if isempty(input_method)
    input_method=2;
end
No_on_table=input('How many people per table?  ');
disp('The longer the programme runs  runs the more accurate it is.')
max_time=input('How long would you like the programme to run. 1 for timed 2 for unlimited ');
if isempty(max_time)
    input_method=1;
end
if max_time==1
    tmax=input('How many minutes would you like the programme to run for? ');
end

if input_method==2
%manual inputs
No_people=input('How many people are going?  ');
%Input People
prompt='Please input the names of the people involved  ';
n=1;
while n<(No_people+1)  
Name=input(prompt,'s');
Names(n)=cellstr(Name);
n=n+1;
end
%Input Values
i=1;
while i<(No_people+1)
    Name1=string(Names(i));
    title1="s opinion of people between -5 and 5. Input 100 for relationship";
    title=[Name1, title1];
    title=char(join(title));
    Question_names=setdiff(Names,Name1,'stable');
Rank=inputdlg(Question_names,title,[1 110]);
Rank=reshape(Rank,1,No_people-1);
Rank1=[Rank(1:i-1) 0 Rank(i:end)];
   Rank2=string(Rank1);
    Rank2=str2double(Rank2);
    Rank2(i)=0;
   Rankall(i,:)=Rank2;
i=i+1;
end


% Excel input method
else
    disp('Select the Excel file to use');
    Excel_file=uigetfile('.xlsx');
    [Rankall,Names,raw]=xlsread(Excel_file,'Sheet2');
    Names=unique(Names,'stable');
    Names(ismember(Names,'empty'))=[];
    Names(ismember(Names,'N/A'))=[];
    Names(1)=[];
    Names=reshape(Names,1,numel(Names));
    No_people=numel(Names);
end
%end inputs    

No_people_matrix=[1:1:No_people];
if No_people<No_on_table
    possible_var=factorial(No_on_table);
else
possible_var=factorial(No_people);
end
Iter_max=ceil(possible_var*(log(possible_var)+0.577216)+0.5);
if Iter_max==inf
    Iter_max=realmax;    
end
if and(max_time==4,Iter_max==realmax)
    disp('Due to the high number of possible values the calculation has been limited to 1.7977e+308 Iterations')
end
Iter=0;
No_of_tables=ceil(No_people/No_on_table);
extra_needed=(No_of_tables*No_on_table)-No_people;
%time limits

if No_of_tables>1
tables_checked=zeros(1,No_people+No_of_tables+extra_needed);
elseif No_people<No_on_table
    tables_checked=zeros(1,No_on_table);
else
    tables_checked=zeros(1,No_people);
end

%choose loop ender
time=0;
if max_time==2
    end_state=Iter_max;
    loop_counter=Iter;
else
    end_state=tmax;
    loop_counter=time;
end

%create weightings
w_all=zeros(1,floor(No_on_table/2));
i5=0;
while i5<(floor(No_on_table/2))
    w=((No_on_table/2)-i5)/(No_on_table/2);
    w_all(:,(i5+1))=w;
    i5=i5+1;
end
%creating constants
if No_on_table/2==floor(No_on_table/2)
    i6limit=(No_on_table/2);
    else
    i6limit=floor(No_on_table/2);
end
theta=360/No_on_table;
Table_check=(No_people/No_on_table);
best=0;
%prewriting matrices
tables=zeros(No_of_tables,No_on_table);
Hap_indv=zeros(1,i6limit);
Hapall=zeros(No_people,i6limit);
Haptotal=zeros(i6limit,1);
%finding initial time
format shortg
initialtime=clock;
%setting initial wish to run loop
contval=1;

while contval==1
    
while loop_counter<end_state
    %loop counting stuff
    if max_time==4
    loop_counter=Iter;
    else
    loop_counter=time;
    end
    current_time=clock;
    time1=current_time-initialtime;
    if time1==0
        time=0;
    else
    time=time1(3)*24*60+time1(4)*60+time1(5)+time1(6)*1/60;
    end
    Iter=Iter+1;


%Random Table Alocation all different 
    tables=[];
i3=0;
Table_no=1;
while Table_no<=No_of_tables
    final_table=(Table_no==No_of_tables);
    if final_table==1
    table=setdiff(No_people_matrix,tables);
    if numel(table)<No_on_table
        extra=zeros(1,extra_needed);
        table=[table extra];     
    end
    idx=randperm(length(table));
    table=table(idx);
    else
table=randperm(No_people,No_on_table);
    end
tables(Table_no,:)=table;
    Table_no=Table_no+1;
end

%store table layout
if No_of_tables>1
tables_store=tables.';
tables_store=reshape(tables_store,1,numel(tables));
i9=1;
while i9<=No_of_tables   
tables_store=[tables_store(1:(No_on_table*i9)) 0 tables_store((No_on_table*i9+1):end)];
i9=i9+1;
end
    else
        tables_store=tables;
end


%Happiness Calcs
i4=1;
i7=1;
while i7<=No_of_tables
    table=tables(i7,:);
while i4<No_on_table
    i6=1;
    pos_angle=(theta*i4);
    pos=(pos_angle/360)*No_on_table;

    while i6<=i6limit
    pos_angle_left=pos_angle+theta*i6;
    pos_angle_right=pos_angle-theta*i6;
        if pos_angle_left>360
       pos_angle_left=pos_angle_left-360;
        elseif pos_angle_right<0
            pos_angle_right=360+pos_angle_right;
        else
        end
        if pos_angle_left==0
            pos_angle_left=360;
        elseif  pos_angle_right==0
             pos_angle_right=360;
        end
    pos_left=(pos_angle_left/360)*No_on_table;
    pos_right=(pos_angle_right/360)*No_on_table;
    opposite_is_random=and(pos_left==pos_right,table(pos_left)==0);
    if or(table(pos)==0,opposite_is_random)
        Hap=1;
    elseif pos_left==pos_right
        Hap=w_all(i6)*(Rankall(table(pos),table(pos_left)));
    elseif table(pos_left)==0
        Hap=w_all(i6)*(Rankall(table(pos),table(pos_right)));
    elseif table(pos_right)==0
        Hap=w_all(i6)*(Rankall(table(pos),table(pos_left)));
    else
        Hap=w_all(i6)*(Rankall(table(pos),table(pos_left))+Rankall(table(pos),table(pos_right)));
    end
    Hap_indv(:,i6)=Hap;
    i6=i6+1;
    end
    Hapall(i4,:)=Hap_indv;
    i4=i4+1;
end
Haptotal(:,i7)=sum(Hapall);
i7=i7+1;
end
%fitness function
total1=sum(Haptotal);
total=sum(total1);
%recording best config
if total>=best
    best=total;
   best_tables=tables;
end
if Iter==Iter_max
    break
end
end
%end of main loop


i11=1;
while i11-1<No_of_tables
    i8=1;
while i8-1<No_on_table
    if best_tables(i11,i8)==0
        best_tables_names(i11,i8)=cellstr('Random');
    else
    best_tables_names(i11,i8)=Names(best_tables(i11,i8));
    end
i8=i8+1;
end
i11=i11+1;
end
best_tables_names=string(best_tables_names);
disp(best_tables_names);
disp(Iter);
disp(best);
beep;
% cont=input('Would you like to continue running the programme? Y/N ','s');
% if isempty(cont)
%     cont = 'N';
% end
% if cont=='Y'
%     time=0;
%     loop_counter=0;
%     contval=1;
%     tmax=input('How many more minutes should it run for? ');
%     end_state=tmax;
%     initialtime=clock;
% else
    contval=0;
% end

end
xlswrite(Excel_file,best_tables_names,3);
%end