//
//  ChatViewController.swift
//  AliceX
//
//  Created by lmcmz on 20/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class ChatViewController: BaseChatViewController {

    var chatInputPresenter: BasicChatInputBarPresenter!
    
    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()
    
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }
    
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
//        items.append(self.createPhotoInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
          // Your handling logic
        }
        return item
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        let photoMessagePresenter = PhotoMessagePresenterBuilder(
                   viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
                   interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
               )
               photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()

       let compoundPresenterBuilder = CompoundMessagePresenterBuilder(
           viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
           interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler),
           accessibilityIdentifier: nil,
           contentFactories: [
               .init(DemoTextMessageContentFactory()),
               .init(DemoImageMessageContentFactory()),
               .init(DemoDateMessageContentFactory())
           ],
           compoundCellDimensions: .defaultDimensions,
           baseCellStyle: BaseMessageCollectionViewCellAvatarStyle()
       )
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
            ChatItemType.compoundItemType: [compoundPresenterBuilder]
        ]
    }

//    private func createPhotoInputItem() -> PhotosChatInputItem {
//        let item = PhotosChatInputItem(presentingController: self)
//        item.photoInputHandler = { [weak self] image in
//          // Your handling logic
//        }
//        return item
//    }
    
    override func viewDidLoad() {
        dataSource = DemoChatDataSource(messages: DemoChatMessageFactory.makeOverviewMessages(), pageSize: 50)
        super.viewDidLoad()
        messagesSelector.delegate = self
        chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
//        chatDataSource = 
        // Do any additional setup after loading the view.
    }

}


extension ChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}
