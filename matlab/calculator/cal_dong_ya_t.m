function q= cal_dong_ya_t(Ma,H)
%���㶯ѹ��H Ma�����ݸ�ʽ�����У���ʱ�䡣����� q Ҳ�����У���ʱ��t

q=calDongYa(Ma(:,2),H(:,2));
q(:,2)=q;
q(:,1)=H(:,1);
end

