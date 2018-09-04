//
//  AgendaItemEditorHeaderDelegate.swift
//  Slickster
//
//  Created by NonGT on 9/28/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

protocol AgendaItemEditorHeaderDelegate {
    
    func agendaItemEditorCategoryActivated(
        editorHeader: AgendaItemEditorHeaderView,
        typeCategories: AgendaTypeCategories!,
        eventBriteCategories: [EventbriteCategory]!,
        selectedCategory: AnyObject?,
        parentCategory: AnyObject?)
    
    func agendaItemEditorTimeActivated(
        editorHeader: AgendaItemEditorHeaderView,
        selectedTime: AgendaTime)
    
    func agendaItemEditorDistanceChanged(
        editorHeader: AgendaItemEditorHeaderView,
        distance: Float)
    
    func agendaItemEditorSortModeChanged(
        editorHeader: AgendaItemEditorHeaderView,
        sortMode: String)
}