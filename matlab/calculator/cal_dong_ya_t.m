function q= cal_dong_ya_t(Ma,H)
%计算动压，H Ma的数据格式是两列，带时间。输出的 q 也是两列，带时间t

q=calDongYa(Ma(:,2),H(:,2));
q(:,2)=q;
q(:,1)=H(:,1);
end

