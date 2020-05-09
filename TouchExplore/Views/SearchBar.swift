import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

	let searchBar:UISearchBar = UISearchBar(frame: .zero)
	
	init(_ placeholder: String, text: Binding<String>) {
		self._text = text
				
		searchBar.placeholder = placeholder
	}
	
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
		
		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			text = ""
			
			searchBar.setShowsCancelButton(false, animated: true)
			searchBar.endEditing(true)
			
			searchBar.resignFirstResponder()
		}
		
		func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
		
			return true
		}
		
		func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(false, animated: true)
			
			return true
		}
		
    }
	
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        searchBar.delegate = context.coordinator
		
        searchBar.autocapitalizationType = .none
		
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
	
	func style(_ style: UISearchBar.Style) -> SearchBar {
		searchBar.searchBarStyle = style
		
		return self
	}
}
//
//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//    }
//}

struct SearchBar_Previews: PreviewProvider {
	@State static var text: String = ""
	
	static var previews: some View {
		SearchBar("Nach etwas suchen", text: $text)
	}
}
