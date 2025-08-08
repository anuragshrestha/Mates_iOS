//
//  PostOptionModal.swift
//  Mates
//
//  Created by Anurag Shrestha on 8/5/25.
//

import SwiftUI

struct PostOptionModal: View {
    
    @Binding var showModal: Bool
    @Binding var showDeleteModal: Bool
    @Binding var showEditModal: Bool
  
  
    
    var body: some View {
       
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.5))
                .frame(width:40, height:5)
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            
            VStack(spacing: 0) {
                Button(action:{
                    showModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showEditModal = true
                    }
                }){
                    HStack{
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                        
                        Text("Update Post")
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                   
                }
                
                
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                
                Button(action: {
                    showModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        showDeleteModal = true
                    }
                }){
                    HStack{
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                        
                        Text("Delete Post")
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        
    }
}


