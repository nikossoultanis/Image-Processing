clear;
ball = im2double(imread('ball.jpg'));
ball_mask = 1-im2double(imread('ball_mask.jpg'));
beach = im2double(imread('beach.jpg'));
ball1 = imresize(ball, [200, 200]);
ball_mask1 = imresize(ball_mask, [200, 200]);
x = -pi:0.0101:pi;

movement = -10*abs(2*exp(-x).*cos(6*pi*x));
for i=1:1:length(movement)
    ball = imresize(ball1, [200, 200]);
    ball_mask = imresize(ball_mask1, [200, 200]);
    
    ball = imrotate(ball,20*i,'nearest','crop');
    ball_mask = imrotate(ball_mask,20*i,'nearest','crop');
    %     ball = ball.*(1-ball_mask);
    ball = padarray(ball,[549,1400],'post');
    ball = flip(ball);
    ball_mask = padarray(ball_mask, [549,1400],'post');
    ball_mask = flip(ball_mask);
    
    ball = imtranslate(ball,[30*i,movement(i)],'nearest', 'OutputView', 'same');
    ball_mask = imtranslate(ball_mask, [30*i,movement(i)], 'nearest', 'OutputView', 'same');
    imshow(ball.*(ball_mask)+beach.*(1-ball_mask));
    
end