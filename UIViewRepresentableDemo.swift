//
//  ContentView.swift
//  UIViewRepresentableDemo
//
//  Created by Daniel Spalek on 04/09/2022.
//

import SwiftUI

/*
 
 This file teaches how to take UIKit views and put it in our SwiftUI App.
 
 Also teaches how to send data from UIKit to our SwiftUI app and the opposite.
 
 And also we learned how to customize the UIKit view (Create custom initializers, pass in custom data and add functions to explicitly update data inside the UIViewRepresentable after it's already been initialized.
 
 */

struct BasicUIViewRepresentable: UIViewRepresentable {
    
    // we need 2 functions to conform to the protocol: make and update.
    func makeUIView(context: Context) -> some UIView {
        // gets called upon initialization. here we will make the view and modify it just like in UIKit app.
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // gets called after makeUIView.
    }
    
//    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
//        // This is to specify a size for our view
//        return nil
//    }
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    // We can also customize the intializer
    var placeholder: String // var so we can update later
    let placeholderColor: UIColor
    // so we can use typed text
    @Binding var text: String
    
    /* if we don't want to have to include color for example we have to create a custom init. in the init below, the default color is blue. */
    init(text: Binding<String> ,placeholder: String, placeholderColor: UIColor = .blue) {
        self._text = text // we access it with underscore because it's a @binding var.
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        /* We can change the return type from some UIView to UITextField. because UITextField is some UIView. we do this so we can do modifications in updateUIView. */
        let textField = makeTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    /* Used to send data from SwiftUI to UIKit*/
    func updateUIView(_ uiView: UITextField, context: Context) {
        /* we want swiftui to update our uikit component too so we use this. */
        /* The uiView is the same UIView in the makeUIView function and the context is the same context too. */
        uiView.text = text
    }
    
    /* Used to send data from UIKit to SwiftUI */
    func makeCoordinator() -> Coordinator {
        /* with a coordinator we can communicate changes from our UIKit view to our SwiftUI app */
        return Coordinator(text: $text)
    }
    /* we are only going to use this coordinator in this struct is why we are creating it inside it. */
    class Coordinator: NSObject, UITextFieldDelegate {
        /* coordinators are our way to create delegates in SwiftUI for our UIKit views. */
        @Binding var text: String /* We need to bind this again. */
        init(text: Binding<String>) {
            self._text = text /* we are setting the binding text of this current class to the text we recieve in the initializer. */
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    private func makeTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        
        /* we can customize the placeholder like this by creating NSAttributedString */
        let placeholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor : placeholderColor
        ])
        
        textField.attributedPlaceholder = placeholder
        
        return textField
    }
    
    func updatePlaceholder(to text: String) -> UITextFieldViewRepresentable {
        /* it need to return a new version of our UITextFieldViewRepresentable. is why this function returns that. */
        var viewRepresentable = self
        /* assigning ourselves to variable so we can directly change the placeholder and return the new version with updated placeholder */
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
}


struct UIViewRepresentableDemo: View {
    @State private var text: String = ""
    var body: some View {
        VStack(spacing: 30) {
            // SwiftUI non customizable
            TextField("Type in SwiftUI noncustomizale textfield here...", text: $text)
            // SwiftUI customizable
            TextField(text: $text) {
                Text("Customizable SwiftUI textfield...")
                    .foregroundColor(.green)
            }
            // UIKit cuztomizable
            UITextFieldViewRepresentable(text: $text, placeholder: "Type in uIKit textfield here...", placeholderColor: .systemBlue)
                .updatePlaceholder(to: "We can update the placeholder too...")
                .frame(height: 55)
                .background(.gray)
            /*
             The challenge comes when we need to send data to and from our UIKit components.
             */
        }
        .padding()
    }
}

struct UIViewRepresentableDemo_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableDemo()
    }
}
