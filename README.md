# service95
Learning SwiftUI with Dua Lipa's Blog - Service95
# ContactView SwiftUI Project

This SwiftUI project showcases a `ContactView` with a rotating, color-changing sphere, and contact information for Service95.

## Project Structure

The project consists of the following main components:

1. **ContactView**: A SwiftUI view displaying the rotating sphere and various contact sections.
2. **ContactTextView**: A custom SwiftUI view used for displaying contact details.
3. **RotatingColorChangingSphereView**: A SwiftUI view with a SceneKit sphere that rotates and changes color periodically.
4. **ColorGenerator**: A singleton class generating a sequence of colors for the sphere.

## Main Components

### ContactView

The `ContactView` is the main view containing a list of contact sections and a rotating sphere.

```swift
import SwiftUI
import SceneKit

struct ContactView: View {
    var body: some View {
        List {
            VStack {
                Section {
                    RotatingColorChangingSphereView()
                        .frame(width: 300, height: 300)
                        .edgesIgnoringSafeArea(.all)
                } header: {
                    Text("Contact Us")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                Section {
                    ContactTextView(title: "For general enquiries, please email:", description: "info@service95.com")
                }
                Section {
                    ContactTextView(title: "For editorial pitches, please email:", description: "editors@service95.com")
                }
                Section {
                    ContactTextView(title: "For Book Club enquiries, please email:", description: "books@service95.com")
                }
                Section {
                    ContactTextView(title: "For press enquiries, please email:", description: "info@permanentpressmedia.com")
                }
                Section {
                    ContactTextView(title: "Careers:", description: "There are currently no vacancies at Service95. Check back here for any future opportunities.")
                }
                Section {
                    ContactTextView(title: "Follow us at:", description: "Instagram @service95\nTwitter @service95\nTikTok @service95")
                }
            }
        }
    }
}

#Preview {
    ContactView()
}
