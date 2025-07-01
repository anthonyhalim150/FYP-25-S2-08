import React, {useState} from 'react';
import SideBar from '../components/SideBar'; // Assuming your SideBar is in components folder
import TopBar from './TopBar';
import './PageLayout.css';
import '../styles/Styles.css';
import { useSearchParams } from 'react-router-dom';

const PageLayout = ({ children }) => {
    const [searchTerm, setSearchTerm] = useState('');

    return (
        <div className="admin-layout">
        <TopBar searchTerm={searchTerm} onSearch={(setSearchTerm)}/>
        <div className='layout-body'>
        <SideBar />
        <main className="admin-main">
            {children}
        </main>
        </div>
        </div>
    );
    };

export default PageLayout;