//
//  FeedBackIdeaTableViewCell.m
//  Muse
//
//  Created by paycloud110 on 16/7/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "FeedBackIdeaTableViewCell.h"
#import "MBProgressHUD+Simple.h"
#import "MuseUser.h"

@interface FeedBackIdeaTableViewCell () <UITextViewDelegate, UITextFieldDelegate> {
    
    UITextView *_feedbackTextView;
    UITextField *_contactTextField;
    
    BOOL _setuped;
}

@end

@implementation FeedBackIdeaTableViewCell

- (void)setupChildView {
    if (_setuped) {
        return;
    }
    _setuped = YES;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xefefef);
    [self.contentView addSubview:backView];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.text = NSLocalizedString(@"Problem description", nil);
    detailLabel.textColor = UIColorFromRGBA(0x000000, 0.8);
    [detailLabel sizeToFit];
    [backView addSubview:detailLabel];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [backView addSubview:contentView];
    
    _feedbackTextView = [[UITextView alloc] init];
    _feedbackTextView.delegate = self;
    _feedbackTextView.font = [UIFont systemFontOfSize:16];
    _feedbackTextView.text = NSLocalizedString(@"Feedback Content", nil);
    _feedbackTextView.textColor = UIColorFromRGBA(0x000000, 0.4);
    [_feedbackTextView.layer setBorderColor:UIColorFromRGBA(0x000000, 0.4).CGColor];
    [contentView addSubview:_feedbackTextView];
    
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.font = [UIFont systemFontOfSize:15];
    contactLabel.text = NSLocalizedString(@"Your Contacts Detail", nil);
    contactLabel.textColor = UIColorFromRGBA(0x000000, 0.8);
    [contactLabel sizeToFit];
    [backView addSubview:contactLabel];
    
    UIView *contactView = [[UIView alloc] init];
    contactView.backgroundColor = UIColorFromRGB(0xffffff);
    [backView addSubview:contactView];
    
    _contactTextField = [[UITextField alloc] init];
    _contactTextField.delegate = self;
    _contactTextField.font = [UIFont systemFontOfSize:16];
    _contactTextField.textColor = UIColorFromRGBA(0x000000, 0.4);
    _contactTextField.text = [MuseUser currentUser].phone ? : NSLocalizedString(@"Your Contacts Detail", nil);
    [contactView addSubview:_contactTextField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_suggest_send"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_suggest_send_press"] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sendButton];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(20);
        make.left.equalTo(backView.mas_left).offset(26);
        make.width.equalTo(@(detailLabel.width));
        make.height.equalTo(@(20));
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).offset(20);
        make.left.equalTo(backView.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.height.equalTo(@(180));
    }];
    [_feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(10);
        make.left.equalTo(contentView.mas_left).offset(26);
        make.bottom.equalTo(contentView.mas_bottom).offset(0);
        make.right.equalTo(contentView.mas_right).offset(-26);
    }];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(20);
        make.left.equalTo(backView.mas_left).offset(26);
        make.width.equalTo(@(contactLabel.width));
        make.height.equalTo(@(20));
    }];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactLabel.mas_bottom).offset(20);
        make.left.equalTo(backView.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(0);
        make.height.equalTo(@(60));
    }];
    [_contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contactView.mas_centerY);
        make.left.equalTo(contactView.mas_left).offset(26);
        make.right.equalTo(contactView.mas_right).offset(-26);
        make.height.equalTo(@(33));
    }];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactView.mas_bottom).offset(54);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@(131));
        make.height.equalTo(@(38));
    }];
}

- (void)sendButtonClicked {
    if (_feedbackTextView.text.length < 5) {
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"feedback lim3word", nil)];
        return;
    }
    
    if (_contactTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessageOnly:NSLocalizedString(@"feedback youcontact", nil)];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(feedBackIdeaTableViewCell:withFeedback:contact:)]) {
        [_delegate feedBackIdeaTableViewCell:self withFeedback:_feedbackTextView.text contact:_contactTextField.text];
    }
}

#pragma mark --<UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.textColor = UIColorFromRGBA(0x000000, 0.4);
    [textView setText:@""];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *string = textView.text;
    if (string.length == 0) {
        textView.text = NSLocalizedString(@"Feedback Content", nil);
    }
}

#pragma mark --<UITextFieldDelegate>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.textColor = UIColorFromRGBA(0x000000, 0.4);
    [textField setText:@""];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *string = textField.text;
    if (string.length == 0) {
        textField.text = NSLocalizedString(@"Your Contacts Detail", nil);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
