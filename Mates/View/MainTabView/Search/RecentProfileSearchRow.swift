
import SwiftUI


struct RecentProfileSearchRow: View {
    let profile: SimpleRecentProfileModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            AsyncImage(url: URL(string: profile.visitedUserData.profileImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 40))
            }
            .frame(width: 45, height: 45)
            .clipShape(Circle())
            
            // User Info
            VStack(alignment: .leading, spacing: 3) {
                Text(profile.visitedUserData.fullName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(profile.visitedUserData.universityName)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Time ago and clock icon
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))
                
                Text(profile.visitedAt.timeAgoDisplay())
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.03))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }
}
